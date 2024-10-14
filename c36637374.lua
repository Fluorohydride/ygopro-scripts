--烙印開幕
---@param c Card
function c36637374.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,36637374)
	e1:SetTarget(c36637374.target)
	e1:SetOperation(c36637374.activate)
	c:RegisterEffect(e1)
	--avoid destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36637375)
	e2:SetTarget(c36637374.reptg)
	e2:SetValue(c36637374.repval)
	e2:SetOperation(c36637374.repop)
	c:RegisterEffect(e2)
end
function c36637374.selfilter(c,e,tp,check)
	return c:IsSetCard(0x164) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function c36637374.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c36637374.selfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c36637374.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c36637374.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.BreakEffect()
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c36637374.selfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
		if #g==0 then return end
		local tc=g:GetFirst()
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c36637374.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c36637374.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c36637374.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c36637374.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c36637374.repval(e,c)
	return c36637374.repfilter(c,e:GetHandlerPlayer())
end
function c36637374.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
