--竜儀巧－メテオニス＝QUA
---@param c Card
function c95209656.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c95209656.valcheck)
	c:RegisterEffect(e0)
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c95209656.efilter)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95209656,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95209656)
	e2:SetCondition(c95209656.descon)
	e2:SetTarget(c95209656.destg)
	e2:SetOperation(c95209656.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c95209656.matcon)
	e3:SetOperation(c95209656.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95209656,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,95209657)
	e4:SetCondition(c95209656.spcon)
	e4:SetTarget(c95209656.sptg)
	e4:SetOperation(c95209656.spop)
	c:RegisterEffect(e4)
end
function c95209656.efilter(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c95209656.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c95209656.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(95209656,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95209656,2))
end
function c95209656.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c95209656.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c95209656.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c95209656.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(95209656)>0
end
function c95209656.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c95209656.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c95209656.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c95209656.spfilter(c,e,tp)
	return c:IsSetCard(0x154) and c:IsAttackAbove(1) and not c:IsCode(95209656)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,aux.DrytronSpSummonType(c))
end
function c95209656.fselect(g)
	return g:GetSum(Card.GetAttack)==4000
end
function c95209656.gcheck(g)
	return g:GetSum(Card.GetAttack)<=4000
end
function c95209656.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95209656.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then
		if ft<=0 then return false end
		local ct=math.min(ft,#g)
		aux.GCheckAdditional=c95209656.gcheck
		local res=g:CheckSubGroup(c95209656.fselect,1,ct)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c95209656.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c95209656.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft<=0 then return end
	local ct=math.min(ft,#g)
	aux.GCheckAdditional=c95209656.gcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c95209656.fselect,false,1,ct)
	aux.GCheckAdditional=nil
	if sg then
		for tc in aux.Next(sg) do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,aux.DrytronSpSummonType(tc),POS_FACEUP) and aux.DrytronSpSummonType(tc) then
				tc:CompleteProcedure()
			end
		end
		Duel.SpecialSummonComplete()
	end
end
