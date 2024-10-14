--インフェルニティ・ポーン
---@param c Card
function c82434071.initial_effect(c)
	--Optional
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82434071,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCondition(c82434071.opcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c82434071.optg)
	e1:SetOperation(c82434071.opop)
	c:RegisterEffect(e1)
end
function c82434071.opcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c82434071.ttopfilter(c)
	return c:IsSetCard(0xb)
end
function c82434071.ssetfilter(c)
	return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c82434071.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c82434071.ttopfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
	local b2=Duel.IsExistingMatchingCard(c82434071.ssetfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and (b1 or b2) end
	aux.GiveUpNormalDraw(e,tp)
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(82434071,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(82434071,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c82434071.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82434071,3))
		local g=Duel.SelectMatchingCard(tp,c82434071.ttopfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c82434071.ssetfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
