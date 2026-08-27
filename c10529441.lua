--嗚呼な落とし穴
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetFlagEffect(1-tp,id)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsDestructable() end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,rc:GetSequence(),1-tp)
	g:AddCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desfilter(c,seq,tp)
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if c:GetControler()~=tp then
		if not (seq==1 or seq==3) then return end
		return seq==1 and cseq==6 or seq==3 and cseq==5
	end
	if cloc==LOCATION_SZONE then
		if cseq>=5 then return false end
		if seq<5 then return cseq==seq end
	end
	if cloc==LOCATION_MZONE then
		if seq<5 then
			if cseq>=5 then return seq==1 and cseq==5 or seq==3 and cseq==6 end
			if cseq<5 then return math.abs(cseq-seq)==1 end
		end
		if seq>=5 then return seq==5 and cseq==1 or seq==6 and cseq==3 end
	end
	return false
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToChain(ev) and rc:IsLocation(LOCATION_MZONE) then
		local seq=rc:GetSequence()
		if Duel.Destroy(rc,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,seq,rc:GetPreviousControler())
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
