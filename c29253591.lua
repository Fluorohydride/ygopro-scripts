--ドラグニティ－クーゼ
function c29253591.initial_effect(c)
	--synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c29253591.synlimit)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c29253591.slevel)
	c:RegisterEffect(e2)
	--special summon while equipped
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29253591,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c29253591.sptg)
	e3:SetOperation(c29253591.spop)
	c:RegisterEffect(e3)
end
function c29253591.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x29)
end
function c29253591.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c29253591.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29253591.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
