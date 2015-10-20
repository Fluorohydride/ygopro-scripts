--Dynaster Pendulum, the Powerful Dracoslayer
function c22638495.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22638495.spcon)
	e1:SetOperation(c22638495.spop)
	c:RegisterEffect(e1)
	--Other effects
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22638495.sptg)
	e2:SetOperation(c22638495.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_SZONE,0)
	e3:SetTarget(c22638495.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE+LOCATION_SZONE,0)
	e4:SetTarget(c22638495.indtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end


function c22638495.spfilter1(c,tp)
	return ((c:IsSetCard(0xc7) and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial()) or c:IsCode(92746535))
		and Duel.CheckReleaseGroup(tp,c22638495.spfilter2,1,c)
end
function c22638495.spfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial()
end
function c22638495.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c22638495.spfilter1,1,nil,tp)
end
function c22638495.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c22638495.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c22638495.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end

function c22638495.pspfilter(c,e,tp)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22638495.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22638495.pspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22638495.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22638495.pspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c22638495.indtg(e,c)
	return c:IsType(TYPE_PENDULUM) and (c:GetLocation(LOCATION_MZONE) or (c:GetSequence()==6 or c:GetSequence()==7))
end
