--スプリガンズ・シップ エクスブロウラー
local s,id,o=GetID()
---@param c Card
function c62941499.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62941499,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,62941499)
	e1:SetTarget(c62941499.seqtg)
	e1:SetOperation(c62941499.seqop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62941499,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_END)
	e2:SetCountLimit(1,62941500)
	e2:SetCondition(c62941499.rmcon)
	e2:SetTarget(c62941499.rmtg)
	e2:SetOperation(c62941499.rmop)
	c:RegisterEffect(e2)
end
function c62941499.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c62941499.exmzfilter(c,seq)
	return c:GetSequence()==seq
end
function c62941499.seqfilter(c,seq,tp)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c62941499.exmzfilter,tp,0,LOCATION_MZONE,1,nil,seq) then
		return seq==5 and cseq==1 or seq==6 and cseq==3
	end
	return cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1
end
function c62941499.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c62941499.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,15 do
		if not Duel.IsExistingMatchingCard(c62941499.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i,tp) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(c62941499.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c62941499.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(c62941499.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	if ct<=0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local count=c:RemoveOverlayCard(tp,1,ct,REASON_EFFECT)
	if count<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c62941499.seqfilter,tp,0,LOCATION_ONFIELD,count,count,nil,seq,tp)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c62941499.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c62941499.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c62941499.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c62941499.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c62941499.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
