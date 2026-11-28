--ゴーストリック・アート
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
end
function s.rfilter(c,tp)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_MONSTER)
		and (c:IsControler(tp) or c:IsFaceup())
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x8d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function s.getrg(tp)
	return Duel.GetReleaseGroup(tp,true,REASON_EFFECT):Filter(s.rfilter,nil,tp)
end
--max number of monsters that can be summoned (zones not included)
function s.getmax(e,tp)
	local max=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp):GetClassCount(Card.GetCode)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then max=math.min(max,1) end
	return math.min(max,2)
end
function s.rcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>=#g
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local max=s.getmax(e,tp)
		return max>0 and s.getrg(tp):CheckSubGroup(s.rcheck,1,max,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local max=s.getmax(e,tp)
	if max>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=s.getrg(tp):SelectSubGroup(tp,s.rcheck,false,1,max,tp)
		local ct=sg and Duel.Release(sg,REASON_EFFECT) or 0
		--summon exactly that number or nothing; recheck zones and effects that may apply again after releasing (e.g. a negated 59822133)
		if ct>0 then Duel.AdjustAll() end
		if ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE) and ct<=s.getmax(e,tp) then
			local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
			local posmap={}
			local cg=Group.CreateGroup()
			for sc in aux.Next(tg) do
				local spos=0
				if sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
				if sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
				local pos=Duel.SelectPosition(tp,sc,spos)
				posmap[sc]=pos
				if pos==POS_FACEDOWN_DEFENSE then cg:AddCard(sc) end
			end
			if #cg==2 then Duel.ConfirmCards(1-tp,cg) end
			local fg=Group.CreateGroup()
			for sc in aux.Next(tg) do
				local pos=posmap[sc]
				if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,pos) and pos==POS_FACEDOWN_DEFENSE then
					fg:AddCard(sc)
				end
			end
			Duel.SpecialSummonComplete()
			if #fg==1 then Duel.ConfirmCards(1-tp,fg) end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function s.posfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsSetCard(0x8d) and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
