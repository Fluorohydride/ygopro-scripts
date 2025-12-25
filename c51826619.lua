--磁石の戦士Σ＋
local s,id,o=GetID()
function s.initial_effect(c)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.atklimit)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--attack redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(s.podcond)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--spsummon or th hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
function s.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.atklimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function s.podfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function s.podcond(e)
	local tp=e:GetOwnerPlayer()
	return Duel.IsExistingMatchingCard(s.podfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.filter(c,e,tp)
	return not c:IsCode(id) and c:IsLevelBelow(4) and c:IsSetCard(0x2066)
		and (c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
