--黄昏の忍者将軍－ゲツガ
function c76930964.initial_effect(c)
	--normal summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76930964,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c76930964.otcon)
	e1:SetOperation(c76930964.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,76930964)
	e3:SetCondition(c76930964.spcon)
	e3:SetTarget(c76930964.sptg)
	e3:SetOperation(c76930964.spop)
	c:RegisterEffect(e3)
end
function c76930964.otfilter(c,tp)
	return c:IsSetCard(0x2b) and (c:IsControler(tp) or c:IsFaceup())
end
function c76930964.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c76930964.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c76930964.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c76930964.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c76930964.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c76930964.filter(c,e,tp)
	return c:IsSetCard(0x2b) and not c:IsCode(76930964) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76930964.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c76930964.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c76930964.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76930964.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c76930964.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsDefensePos() then return end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
