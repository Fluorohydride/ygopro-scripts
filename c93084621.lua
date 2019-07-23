--破械神アルバ
function c93084621.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c93084621.lcheck)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93084621,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,93084621)
	e1:SetTarget(c93084621.target)
	e1:SetOperation(c93084621.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93084621,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,93084622)
	e2:SetCondition(c93084621.thcon)
	e2:SetTarget(c93084621.thtg)
	e2:SetOperation(c93084621.thop)
	c:RegisterEffect(e2)
end
function c93084621.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1130)
end
function c93084621.tgfilter(c,tp,ec)
	local mg=Group.FromCards(ec,c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c93084621.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c93084621.lfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(93084621) and c:IsLinkSummonable(mg,nil,2,2)
end
function c93084621.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c93084621.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c93084621.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c93084621.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c93084621.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.LinkSummon(tp,lc,mg,nil,2,2)
		end
	end
end
function c93084621.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c93084621.thfilter(c)
	return c:IsRace(RACE_FIEND) and not c:IsCode(93084621) and c:IsAbleToHand()
end
function c93084621.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c93084621.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c93084621.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c93084621.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c93084621.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
