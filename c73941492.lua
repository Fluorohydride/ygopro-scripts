--調弦の魔術師
--fusion limit not implemented
--xyz limit by edo9300
function c73941492.initial_effect(c)
	local xmck=Duel.CheckXyzMaterial
	Duel.CheckXyzMaterial=function(c,f,lv,minc,maxc,og)
		local og2=Group.CreateGroup()
		if not og then
			og=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		end
		if og:IsExists(Card.IsCode,1,nil,73941492) then
			og2=og:Filter(c73941492.xyzfil3,nil)
			og=og:Filter(c73941492.xyzfil,nil,c,lv)
		end		
		return xmck(c,f,lv,minc,maxc,og) or xmck(c,f,lv,minc,maxc,og2)
	end
	local xsel=Duel.SelectXyzMaterial
	Duel.SelectXyzMaterial=function(tp,c,f,lv,minc,maxc,og)
		if not og then
			og=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(c73941492.xyzfil2,nil,c,lv,tp)
		end
		local og2=og:Filter(c73941492.xyzfil3,nil)
		if og:IsExists(Card.IsCode,1,nil,73941492) then
			if og:IsExists(c73941492.xyzfil,minc,nil,c,lv) and xmck(c,f,lv,minc,maxc,og2) then
				if Duel.SelectYesNo(tp,aux.Stringid(73941492,1)) then
					og=og:Filter(c73941492.xyzfil,nil,c,lv)
				else 
					og=og2
				end
			elseif og:IsExists(c73941492.xyzfil,minc,nil,c,lv) and not xmck(c,f,lv,minc,maxc,og2) then
				og=og:Filter(c73941492.xyzfil,nil,c,lv)
			elseif not og:IsExists(c73941492.xyzfil,minc,nil,c,lv) and xmck(c,f,lv,minc,maxc,og2) then
				og=og2
			end
		end
		return xsel(tp,c,f,lv,minc,maxc,og)
	end
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c73941492.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--synchro custom
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c73941492.syntg)
	e4:SetValue(1)
	e4:SetOperation(c73941492.synop)
	c:RegisterEffect(e4)
	--fusion and xyz custom not implemented
	--local e5=Effect.CreateEffect(c)
	--local e6=Effect.CreateEffect(c)
	--spsummon success
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(73941492,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,73941492)
	e7:SetCondition(c73941492.spcon)
	e7:SetTarget(c73941492.sptg)
	e7:SetOperation(c73941492.spop)
	c:RegisterEffect(e7)
end
function c73941492.xyzfil(c,xyzc,lv)
	return c:IsSetCard(0x98) and c:IsXyzLevel(xyzc,lv) and c:IsType(TYPE_PENDULUM)
end
function c73941492.xyzfil2(c,xyzc,lv,tp)
	return c:IsXyzLevel(xyzc,lv) and c:GetControler()==tp or (c:IsHasEffect(EFFECT_XYZ_MATERIAL) and c:GetControler()~=tp)
end
function c73941492.xyzfil3(c)
	return not c:IsCode(73941492)
end
function c73941492.tuner_filter(c)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function c73941492.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function c73941492.atkval(e,c)
	local g=Duel.GetMatchingGroup(c73941492.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
	return g:GetClassCount(Card.GetCode)*100
end
function c73941492.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM) and (f==nil or f(c))
end
function c73941492.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c73941492.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c73941492.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c73941492.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c73941492.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:IsPreviousLocation(LOCATION_HAND)
end
function c73941492.spfilter(c,e,tp)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM) and not c:IsCode(73941492)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73941492.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c73941492.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c73941492.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c73941492.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x47e0000)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
