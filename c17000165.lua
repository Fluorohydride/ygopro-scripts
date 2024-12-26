--レプティレス・リコイル
---@param c Card
function c17000165.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17000165,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,17000165)
	e2:SetTarget(c17000165.destg)
	e2:SetOperation(c17000165.desop)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17000165,1))
	e3:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,17000166)
	e3:SetCondition(c17000165.ctcon)
	e3:SetTarget(c17000165.cttg)
	e3:SetOperation(c17000165.ctop)
	c:RegisterEffect(e3)
end
function c17000165.desfilter(c,tp)
	return c:IsFaceup() and c:IsAttack(0) and Duel.GetMZoneCount(tp,c)>0
end
function c17000165.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17000165.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c17000165.desfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(c17000165.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c17000165.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c17000165.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c17000165.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)~=0 and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17000165.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c17000165.ctfilter(c,tp)
	return c:IsFaceup() and c:IsAttack(0) and c:IsControlerCanBeChanged() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c17000165.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c17000165.ctfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17000165.ctfilter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21179144,0x3c,TYPES_TOKEN_MONSTER,0,0,1,RACE_REPTILE,ATTRIBUTE_EARTH) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c17000165.ctfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c17000165.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21179144,0x3c,TYPES_TOKEN_MONSTER,0,0,1,RACE_REPTILE,ATTRIBUTE_EARTH) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,17000166)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
