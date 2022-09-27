--家電機塊世界エレクトリリカル・ワールド
function c3875465.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,3875465+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c3875465.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3875465,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c3875465.thcon)
	e2:SetTarget(c3875465.thtg)
	e2:SetOperation(c3875465.thop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3875465,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c3875465.mvtg)
	e3:SetOperation(c3875465.mvop)
	c:RegisterEffect(e3)
end
function c3875465.thfilter1(c)
	return not c:IsType(TYPE_FIELD) and c:IsSetCard(0x14b) and c:IsAbleToHand()
end
function c3875465.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3875465.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(3875465,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c3875465.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x14b) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function c3875465.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3875465.cfilter,1,nil,tp)
end
function c3875465.thfilter2(c)
	return c:IsSetCard(0x14b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c3875465.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3875465.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c3875465.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3875465.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c3875465.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x14b)
end
function c3875465.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3875465.mvfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c3875465.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(3875465,3))
	local g=Duel.SelectMatchingCard(tp,c3875465.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
end
