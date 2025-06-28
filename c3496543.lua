--白き森の罪宝
local s,id,o=GetID()
function s.initial_effect(c)
	--- fusion effect
	local e0=FusionSpell.CreateSummonEffect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fscon)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

function s.fscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsRace),tp,LOCATION_MZONE,0,1,nil,RACE_ILLUSION+RACE_SPELLCASTER+RACE_FIEND)
end

function s.spfilter(c,e,tp)
	return c:IsRace(RACE_ILLUSION+RACE_SPELLCASTER+RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local fusion_effect=e:GetLabelObject()
	local res2=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return res1 or res2 end
	local op=0
	if res1 and not res2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
		op=1
	end
	if res2 and not res1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		op=2
	end
	if res1 and res2 then
		op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(id,2),1},
			{res2,aux.Stringid(id,3),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif e:GetLabel()==2 then
		local fusion_effect=e:GetLabelObject()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then Duel.SSet(tp,c) end
end
