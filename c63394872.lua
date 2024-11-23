--ポジションチェンジ
---@param c Card
function c63394872.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63394872,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c63394872.seqtg)
	e2:SetOperation(c63394872.seqop)
	c:RegisterEffect(e2)
end
function c63394872.filter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c63394872.chkfilter(c,cseq)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-cseq)==1
end
function c63394872.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c63394872.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c63394872.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(63394872,1))
	local g=Duel.SelectTarget(tp,c63394872.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local seq=g:GetFirst():GetSequence()
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	e:SetLabel(nseq)
	Duel.Hint(HINT_ZONE,tp,s)
end
function c63394872.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=e:GetLabel()
	local tseq=tc:GetSequence()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tseq>4 or math.abs(tseq-seq)~=1 or not Duel.CheckLocation(tp,LOCATION_MZONE,seq) then return end
	Duel.MoveSequence(tc,seq)
end
